package terraform

import input.tfplan as tfplan

# the allowed values for the tag 'env'
allowed_Environment_values = {
 "app-prod",
 "app-non-prod"
}

#entry point for tags enforcement 
resource := tfplan.resource_changes[_]
#checkTags(resource) {
 # read the tags based on the resource type
 #tags = readTags(resource.type, resource)
 # check for the tag enforcement
 #ensureMandatoryTags(tags)
#}
# every resource to be evaluated will have a 'readTags' function for # itself the returned document should resemble the below structure
# {'tag-name': {value: 'tag-value'}}
readTags("aws_instance", resource) = tags {
 tags = resource.changedAttributes.tags
}
#deny[reason] {
# tags = readTags(resource.type, resource)
# allowed_Environment_values[tags["Environment"].value]
 
# reason := sprintf(
#        "%s: missing required tag %q",
#        [resource.address, tags["Environment"].value]
# )
#}
deny[reason] {
 tags = readTags(resource.type, resource)
 #allowed_Environment_values[tags["Environment"].value]
 resource.change.after["aws_instance"].cpu_core_count * resource.change.after["aws_instance"].cpu_threads_per_core < 8 
 
 reason := sprintf(
        "%s: wrong core count %q",
        [resource.address, tags["Environment"].value]
 )
}
#check if all the mandatory tags are available & have allowed values
#ensureMandatoryTags(tags) {
# allowed_Environment_values[tags["Environment"].value]
#}
checkTagHasValue(tag) {
 re_match("[^\\s]+", tag.value)
}

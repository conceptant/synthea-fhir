This docker image implements BIND Version 9 and includes basic internet utilities and configuration files for authoritative DNS server.

# Q&A

**What is FHIR?**

FHIR (Fast Healthcare Interoperability Resources) is a standard for exchanging healthcare information electronically. You can find more about it here: https://www.hl7.org/fhir/overview.html

**What is Synthea?**

MITRE Synthea is a synthetic patient generator that models the medical history of synthetic patients. You can find more about it here: https://github.com/synthetichealth/synthea/wiki

**What is Conceptant, Inc.?**

Conceptant, Inc. is a business specializing on healthcare solutions. You can read about it here: http://conceptant.com/

**Why would I need this docker image?**

If you're developing or testing a system that needs to process Protected Health Information (PHI) or Personally Identifiable Information (PII) you need to generate a bulk of data that closely resembles the profile of your real future users, but doesn't contain any actual PII/PHI.
Furthermore, you will need to store that data somewhere, so why not store it in an industry-standard HL7 FHIR form on a FHIR server, such as the one you can bring up with this image: https://hub.docker.com/r/conceptant/hapi-fhir/ ?
This docker image does exactly that. It uses MITRE's highly realistic Synthea systhetic patient generator and then pushes all generated data to your FHIR server.

**Is this docker image production-ready?**

This image is intended for generating test data, so you probably don't want to us it in production, but if you need to then why not?
By working exclusivly with synthetic data you significantly reduce security risks.



# How to run this image

There are three ways to use this image:
```
docker run --rm -e SYNTHEA_SEED=<seed> -e SYNTHEA_SIZE=<num_records> -e FHIR_URL=<fhir_server_url> conceptant/synthea-fhir
```
In this form the container will generate <num_records> synthetic patients using seed value <seed> and post them to the FHIR server identified by the v3.0.1 endpoint <fhir_server_url>

If you want to just generate bunch of records, you can use this form:
```
docker run --rm -e SYNTHEA_SEED=<seed> -e SYNTHEA_SIZE=<num_records> -v <docker_host_directory>:/synthea/output conceptant/synthea-fhir
```
In this form the generated records will be placed in <docker_host_directory>:/fhir directory

Finally, you can run it in an interactive form:
```
docker run -it conceptant/synthea-fhir sh
```
In this form you can edit the properties file located at /synthea/src/main/resources/synthea.properties and run synthea as
```
cd /synthea
./run_synthea -p 10
ls output/fhir # the output is located here
```
You can further use "docker cp" command to copy files into or from the container.

# If you need to customize the docker file

```
git clone https://github.com/conceptant/synthea-fhir.git
```

Now make you customizations and build as usual:
```
docker build -t synthea .
```

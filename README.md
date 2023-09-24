# replace_text
replace a particular text with another desired word/phrase


1.Clone the repository 
git clone https://github.com/mnsrnjn/replace_text.git

2.Change the working directory to word_replace
cd word_replace

3. Set the variables for access_key and secret_key, Thease can be passed by creating a auto,tfvar filr or setting them at shell
export access_key="xxxxxxxxxxxxxxxxxxxxxxxx"
export secret_key= "xxxxxxxxxxxxxxxxxxxxxxx"

4.Initialise the terraform
terraform init

5. validate the plan, it will show the detailed information about resources going to be created
terraform plan

6.Once plan is validated everything loks fine, apply the change using terraform and confirm with yes when prompted.
terraform apply 

7.Once the apply is completed it will create the resources it will display the outpus, Please note the value for invocation_url.
example :
Outputs:
invocation_url = <url to be invoked>

8. Now do a post using curl to the invocation url in the follwing format to get the desired work replaced.
curl -X POST -H "Content-Type: application/json" -d '{"input_string": "<text to be replaced>"}' <url to be invoked>

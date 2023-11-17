class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https://github.com/mpalmer/action-validator"
  license "GPL-3.0-only"

  stable do
    url "https://ghproxy.com/https://github.com/mpalmer/action-validator/archive/refs/tags/v0.5.3.tar.gz"
    sha256 "9afc0e12ca04d5373b3788a36b0f174077f7411572877da85a4c92d187751f14"

    # always pull the HEAD commit hash
    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git",
          revision: "c0e78776f848b8ea866f379f159109adf4d62ad5"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "469a5c6e6a2bd18e0d1292887645cb062dcd35cced249191b2a779a828e2ef12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "806e330aa7c346486af0a03379b18b654286b8146be0c0114484cc4c848259cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd3c910fe75cd68ef262cc18e470222482d9b1b597be97ccd1a6764324c7f3c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "28f4effdfa26048e810e10233d19f311333f74f042c6aa231f4860762360f0ac"
    sha256 cellar: :any_skip_relocation, ventura:        "8afa1d2f4bb1807319d745de95c9882f4ae81c50ebc7d1eae109f75411eb061d"
    sha256 cellar: :any_skip_relocation, monterey:       "3a4bd5bdafd2b9ce832610ed67fbbd8d8e58b482e0596fa5bf6fcd322a8548d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de54c0e77883be1ec0b373dd5ab28ace1a63ded5bc539494ddad92673196201a"
  end

  head do
    url "https://github.com/mpalmer/action-validator.git", branch: "main"

    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git", branch: "master"
    end
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/schemastore").install resource("schemastore")

    system "cargo", "install", *std_cargo_args
  end

  test do
    test_action = testpath/"action.yml"
    test_action.write <<~EOS
      name: "Brew Test Action"
      description: "Test Action"
      inputs:
        test:
          description: "test input"
          default: "brew"
      runs:
        using: "node20"
        main: "index.js"
    EOS

    test_workflow = testpath/"workflow.yml"
    test_workflow.write <<~EOS
      name: "Brew Test Workflow"
      on: [push111]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    EOS

    output = shell_output("#{bin}/action-validator --verbose #{test_action}")
    assert_match "Treating action.yml as an Action definition", output

    output = shell_output("#{bin}/action-validator --verbose #{test_workflow} 2>&1", 1)
    assert_match "Fatal error validating #{test_workflow}", output
    assert_match "Type of the value is wrong", output
  end
end
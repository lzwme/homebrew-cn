class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https:github.commpalmeraction-validator"
  license "GPL-3.0-only"

  stable do
    url "https:github.commpalmeraction-validatorarchiverefstagsv0.5.4.tar.gz"
    sha256 "faf6b7ac865f30e24d81cec6b0c7cdbf7eddf113a97d6c5aa49c7c1a9f44a793"

    # always pull the HEAD commit hash
    resource "schemastore" do
      url "https:github.comSchemaStoreschemastore.git",
          revision: "11d1fc36e96803f85324070a018e8457167bb232"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ee9caed6854d367b92e4bad7de7dae6a247c09718c75b6f4d3919d0ff52e430"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804b5e9354680ab010ffec65bcbee8e81d06d57d210bfe75e890756e94eeda16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b31e0f1623daabd6a03ebaf9adaf4a4de2e62c191a444ab4856fd5f3e94d3246"
    sha256 cellar: :any_skip_relocation, sonoma:         "01a5716563eeb1c2b25c65b87ad37f488279bb76717d16a0b1eaea5f3d529b74"
    sha256 cellar: :any_skip_relocation, ventura:        "0d06546c93797134d0fb08ee2a4580c03d22931b4e95c6685d8f04d09d1080d1"
    sha256 cellar: :any_skip_relocation, monterey:       "f56fcc9beab1fb0ce0200ab588b54bb786a79f6a08797fc626c9ee7c2302dfc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81754cf54ccfb597df52d1aa06dd923ca70cb1e0785f767f5ca381891c1113ea"
  end

  head do
    url "https:github.commpalmeraction-validator.git", branch: "main"

    resource "schemastore" do
      url "https:github.comSchemaStoreschemastore.git", branch: "master"
    end
  end

  depends_on "rust" => :build

  def install
    (buildpath"srcschemastore").install resource("schemastore")

    system "cargo", "install", *std_cargo_args
  end

  test do
    test_action = testpath"action.yml"
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

    test_workflow = testpath"workflow.yml"
    test_workflow.write <<~EOS
      name: "Brew Test Workflow"
      on: [push111]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actionscheckout@v4
    EOS

    output = shell_output("#{bin}action-validator --verbose #{test_action}")
    assert_match "Treating action.yml as an Action definition", output

    output = shell_output("#{bin}action-validator --verbose #{test_workflow} 2>&1", 1)
    assert_match "Fatal error validating #{test_workflow}", output
    assert_match "Type of the value is wrong", output
  end
end
class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https:github.commpalmeraction-validator"
  license "GPL-3.0-only"

  stable do
    url "https:github.commpalmeraction-validatorarchiverefstagsv0.6.0.tar.gz"
    sha256 "bdec75f6383a887986192685538a736c88be365505e950aab262977c8845aa88"

    # always pull the HEAD commit hash
    resource "schemastore" do
      url "https:github.comSchemaStoreschemastore.git",
          revision: "7bf746bd90d7e88cd11f0a9dc4bc34c91fbbf7b4"
    end

    # shell completion and manpage support, upstream pr ref, https:github.commpalmeraction-validatorpull82
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchesffcaead14f73c08531313dcb7c300918db576c3baction-validator0.6.0-completion-manpage.patch"
      sha256 "91b0f5170e52537f78e4b196e3b3dd580e3e56e6479f14ba59cdfcff556f4680"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467356ff337f000cdab20947b5f4fa5ead9cbaba83801d0e7862c940f4264a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b79e8f1f28865df8a87a837d22775fb52de8bc9f63875f49cb12bc9bdc9f15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cd34c8e34dd85ed863fcfd4d70572a9b0fa8975a6fbefb7cd0b877a0bd12929"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b4ab4bad8d7bb8cf2df0b8268da4dce66b24c3381a22e3e4e28a636a5b252f"
    sha256 cellar: :any_skip_relocation, ventura:       "49439159f898d39b291cf67394a89be873f1986e1ed5537e8730e3544335d6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664ea399cda470343bb3d8a0690cc9be3cf5e6410f3b16773a6d7396f3c0e940"
  end

  head do
    url "https:github.commpalmeraction-validator.git", branch: "main"

    resource "schemastore" do
      url "https:github.comSchemaStoreschemastore.git", branch: "master"
    end
  end

  depends_on "rust" => :build

  def install
    ENV["GEN_DIR"] = buildpath

    (buildpath"srcschemastore").install resource("schemastore")

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsaction-validator.bash"
    fish_completion.install "completionsaction-validator.fish"
    zsh_completion.install "completions_action-validator"
    man1.install "manaction-validator.1"
  end

  test do
    test_action = testpath"action.yml"
    test_action.write <<~YAML
      name: "Brew Test Action"
      description: "Test Action"
      inputs:
        test:
          description: "test input"
          default: "brew"
      runs:
        using: "node20"
        main: "index.js"
    YAML

    test_workflow = testpath"workflow.yml"
    test_workflow.write <<~YAML
      name: "Brew Test Workflow"
      on: [push111]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actionscheckout@v4
    YAML

    output = shell_output("#{bin}action-validator --verbose #{test_action}")
    assert_match "Treating action.yml as an Action definition", output

    output = shell_output("#{bin}action-validator --verbose #{test_workflow} 2>&1", 1)
    assert_match "Fatal error validating #{test_workflow}", output
    assert_match "Type of the value is wrong", output
  end
end
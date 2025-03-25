class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https:azure.github.ioaztfexport"
  url "https:github.comAzureaztfexport.git",
      tag:      "v0.17.0",
      revision: "9050e2298b51534c174734b9875054091273da63"
  license "MPL-2.0"
  head "https:github.comAzureaztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51eea406a73fa7ae8846c4f210b539ef0fa08c29b50da6d43fa968afd47ca607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51eea406a73fa7ae8846c4f210b539ef0fa08c29b50da6d43fa968afd47ca607"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51eea406a73fa7ae8846c4f210b539ef0fa08c29b50da6d43fa968afd47ca607"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a213dff1bd1d63498619050726b3e3e98e8c4bd72f7d39fed0c86f38524faa"
    sha256 cellar: :any_skip_relocation, ventura:       "42a213dff1bd1d63498619050726b3e3e98e8c4bd72f7d39fed0c86f38524faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a417ab1b40262c35dc6859bd197752e9d9d5a4beb0efb13780946099f8871b48"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}aztfexport -v")
    assert_match version.to_s, version_output

    mkdir "test" do
      no_resource_group_specified_output = shell_output("#{bin}aztfexport rg 2>&1", 1)
      assert_match("Error: retrieving subscription id from CLI", no_resource_group_specified_output)
    end
  end
end
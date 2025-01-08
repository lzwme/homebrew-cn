class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.7.tar.gz"
  sha256 "d4a10e903957c8b1ea1e8425fa396ef9720fc19f5efa1cc064b7c068cfb67fe5"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b4d9796d33ad1aff762165ef5ccbb2bd4686a49925c7ea26a90180a1ccddd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b4d9796d33ad1aff762165ef5ccbb2bd4686a49925c7ea26a90180a1ccddd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70b4d9796d33ad1aff762165ef5ccbb2bd4686a49925c7ea26a90180a1ccddd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "43cd16cf1c623a9c4bfdf5c3a6f77c7509f23ac4dba13afdb34d195c02cd594e"
    sha256 cellar: :any_skip_relocation, ventura:       "43cd16cf1c623a9c4bfdf5c3a6f77c7509f23ac4dba13afdb34d195c02cd594e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e56b997c389f08984b11b6715a0620bc75786dbd40662e83ad0826a8c96fec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end
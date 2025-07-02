class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.224.tar.gz"
  sha256 "2e80deb610414c86b148857410234d7ecd14a36c5deb2f8700e229818a34af7b"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad9e9c6edc7f8701801043e9ea8d59c0f9a551d8df92f030ab9694ceac0e92a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad9e9c6edc7f8701801043e9ea8d59c0f9a551d8df92f030ab9694ceac0e92a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ad9e9c6edc7f8701801043e9ea8d59c0f9a551d8df92f030ab9694ceac0e92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "929e61ab2c15f045ceee4d35da7f62ceb30680ef98cf9ba86ced457f2b363ceb"
    sha256 cellar: :any_skip_relocation, ventura:       "929e61ab2c15f045ceee4d35da7f62ceb30680ef98cf9ba86ced457f2b363ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff41c5b809ae96a4fb678e377852b3076f2c5b3d3774532203900eabda8f6ae0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
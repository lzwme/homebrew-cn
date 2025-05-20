class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.18.0",
      revision: "cc58e3f5a3aa615c6a86275e6f4444b5fdd3cc4e"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e8897f5006e05a0b02b110fe28ca080fbee5bd72f6a0551569b05fb6d74ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6c05eb55a49b6c3252dd7f14d760b84212ce0fcf11a2806d0dd0a55c75c55d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a708f5597c63b3309c7499e03b8ead516e61e6c56ba588bf53c2780ccab1fbbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "31dbea57504dfec926ffc9007b5d39abcb9650f2faf09ed8b6439f044f31d00a"
    sha256 cellar: :any_skip_relocation, ventura:       "c6a1a9c0bed91e760fe7d74ebc48daf4861faf62ae128ddc3a0fc44be6b8b4ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37765d379b168789a2d0e4e4da7df2dc3c5ecc0c30a183498f3d6f3be91b0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fec3420babbe64db84b7e579c1a2aa84ecd2e651601ee8b97bccb64497e0669e"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "binhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output("#{bin}helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
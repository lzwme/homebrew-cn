class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.17.1",
      revision: "980d8ac1939e39138101364400756af2bdee1da5"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "574c5e3187b5b39a7afc98cf26547304327eaeabf0f3a7fefd67eb0156d8085a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d49da547b422833cee417813bbff565234d330c2102cd277cfef44297ae68ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c84fb211184f4aae1e18007a209b3b9e0d85d1a2d61c11fb7f4247e832f9a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d9be02bcd9bbbcb8e8d9ba67775e51d9896c769a1f34908b5c13b7ba7794cb"
    sha256 cellar: :any_skip_relocation, ventura:       "cccf5f69c3559f1d152188fdb3c1e83c6120153bbff9b7855c2e0b3a77f40dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f462eb762840d6425657ba54027017676fb783d634d20fb8ba954ad4176d801"
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
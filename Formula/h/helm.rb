class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.17.2",
      revision: "cc0bbbd6d6276b83880042c1ecb34087e84d41eb"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f24fb2015fe57f59e8e079252f071d90735b1cf2bf6937a607df5505153445a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4aea2150901fcfb0555ed94dc21aad5cb81b1f5863922ba16edf3c1cff60a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fc270fcee49e1cc741b5f7af33d80e1239acf6264e839ac552de9737146c5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "890ec886ab293163fdbc6fbca1eb08664aa218464d4fb3ad7bf7ef88412665a9"
    sha256 cellar: :any_skip_relocation, ventura:       "f703000ddeca95f1ab6f7682e23a81c66de608652e4e0bcaf8e1158ce627627b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6e80db3a0ed3316ea3d3bb7cc1e366df2c5f2ff782b04f6f5dae4b267505df"
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
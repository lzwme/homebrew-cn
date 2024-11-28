class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.7.0.tar.gz"
  sha256 "59d69e130dccad1784357ac31e929178e49396af1478c8964acef9e3de9710d3"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c944f6ce49e1e27619ea86be512e8c47ccaa22f6ca5badf6b4064edd9ac56f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c944f6ce49e1e27619ea86be512e8c47ccaa22f6ca5badf6b4064edd9ac56f6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c944f6ce49e1e27619ea86be512e8c47ccaa22f6ca5badf6b4064edd9ac56f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f298fb9a33548818e0dd9060c76a52f3973f3f759de9458a851677444b51b08c"
    sha256 cellar: :any_skip_relocation, ventura:       "f298fb9a33548818e0dd9060c76a52f3973f3f759de9458a851677444b51b08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8547866abff65f62744c3840903758232f00cb619ef767ecaf82a2d8f5dccc0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end
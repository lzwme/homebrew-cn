class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://ghfast.top/https://github.com/walles/riff/archive/refs/tags/3.6.0.tar.gz"
  sha256 "2583fbf797033d87a9a2ee8b05c331070f9acb2e6a8a336f5eee14a31361a511"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "179163b020d8df8a89ce8966852617e5731876c81d4b3d011645d34f9e5db38e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a65b1633796f2a31de2af59ffba07d40a7da214b8fcdb3cde33a5d65a0762b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d63382afdbe21a7fa790da6a6a1fa145653b6d8a74e4b7f59e3f1e6765caae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c95877d9e8a39f5fe1e03655954d60c2a57430596bdc26f431e2da0b4d8c84e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e32c6c246b46471a1311e0f984f94423a949b9fa80f98b1cb6f48e2e7a026a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34c5e9bcf4abec7ea05336c761ff1c05821d568cc55732f128ca704357c8a3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
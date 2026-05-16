class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.5.0.tar.gz"
  sha256 "1d4a57cddd7b0e47300312246ce53b440494b4a43bb1937d5f133b8b4c97fd1a"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82eb5d1b8f65bf159cdc3c110cd005a751a2ae618a4888c385e764af4b66b4bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82eb5d1b8f65bf159cdc3c110cd005a751a2ae618a4888c385e764af4b66b4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82eb5d1b8f65bf159cdc3c110cd005a751a2ae618a4888c385e764af4b66b4bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1a32615a227f0666bb0ed3f6e18383837058dbc16e299a000edb13b340eeafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa0190a41e7e57407c16dc6c68e12ae02a111b2b9c935afe216e1c38abaab9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f3f955524defb2a0cb8459dd03408a138f4d22ec0f4802deed97a255306b59"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
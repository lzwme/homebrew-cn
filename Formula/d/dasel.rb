class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "a7ca204fec11a80eeca4d02f78c90d11b9ecc4f7e40e290ce112436979c66f71"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd9c409645378f7d12e2e3f9002ce32a5999b19e2357b87cb1fa44dc63dda5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd9c409645378f7d12e2e3f9002ce32a5999b19e2357b87cb1fa44dc63dda5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd9c409645378f7d12e2e3f9002ce32a5999b19e2357b87cb1fa44dc63dda5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cea72a8195466e311e35f6f7009629f9449b44a7eeb479ea87812f33df9bb647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f548b8f448cc4379472764353bba6d718454b4a2096e9a931a5c8db649359bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73458d056860a1bd38aa9beaad39eae09daef04d7266963a083327ef6e394972"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
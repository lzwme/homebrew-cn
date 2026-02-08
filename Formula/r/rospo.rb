class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://ghfast.top/https://github.com/ferama/rospo/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "cc5595c5c7a378774a953f18b156579aa201cbe7589ab7f912e7028df434c3e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e91e2341ffa9e5b46271926b1c106a9abc0e1830675442a14a05fd8a99cf9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e91e2341ffa9e5b46271926b1c106a9abc0e1830675442a14a05fd8a99cf9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e91e2341ffa9e5b46271926b1c106a9abc0e1830675442a14a05fd8a99cf9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9563ea06943a5ce9e30499b98497fad37ad2caf109fd39bb06efbd204750a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72b0414b474ca2092c01f838241a445bf1e35c752e90c6b497bbd7592d83aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb14ba71b779c20252f9f9b84cd8bacdd6e76cfc54086aaec50437312e42900c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ferama/rospo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"rospo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_path_exists testpath/"identity"
    assert_path_exists testpath/"identity.pub"
  end
end
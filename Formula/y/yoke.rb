class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.18.3",
      revision: "95a98f7722bb7c9881e6093929972718e5c56e40"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8c49725ac36966d52d4192b7229dc2e94259af86381729e8eb1cb1f11f1517f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2279535a697061386c72383eb90f8cb0059b367b78496e752013f4799ef646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165024b7a9ed31a1abab8d3eafd4cbbc35089b5efdf0a0d36e4d94806ac2e725"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ffc3baa6b0e992347f7eb77b63f403034bc2d94257c6b342fce177a31fc9e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cecee50e492cda40f2e2ea94d205f6f7ec253449bb3c6c9f9783603fad2fca4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d21ef505d2582314807bf5f06612487a69b7ad1c0584e59be1fe8cb375bf8438"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
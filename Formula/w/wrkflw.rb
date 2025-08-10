class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://ghfast.top/https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "90437baf4601baecc6abf7aa682b3609ffb2193d9956e70132acc12a1dac811f"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3e2412a04ec60b21be1e6f9701f2db9055f1781969f9220375c38b043f9989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce30ea6b468f20e1808bb94f66778613e4a7407d6407233419dee8b083aa5a2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e740985afcbd3efe3ceafa1fa070b3c49e06f197dd6190288451d01f6cf614c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f17238788981f6c6e37a57a1d7580a0864a1a9806b45a2bf231a52b6840f06f"
    sha256 cellar: :any_skip_relocation, ventura:       "7bcff8b05c344942b7034e1dcfd7d5cb913882a08efaed3ae0a55892a4692cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ef25253f201c0f1fa1319ed3df9793da812959f5e0cf8438de431498aade35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3185af64369f94f5bd52023efc664b5e4af0dd4e4d7f32ce65960f5af74990e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wrkflw")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
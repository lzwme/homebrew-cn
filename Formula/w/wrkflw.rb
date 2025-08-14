class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://ghfast.top/https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "770769ed53181a2f1a44a03182d4e67543d1e3f7f1221621710d26cd13b781bf"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "039ec7a35724817e6690738dfa1a05cd9a66a4114190d1d827a8821836b99b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "821c28339d0f133dc888f11ecabdaf91202810730b7499b28c4b3ab6c12ace4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6fb130b2b9d7b760e8356ba9daf8dc49bb5e46f11630594daff6ed38bd259d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc8b14fe994f41413007643c98210b86643bfb7e2fd65ce37bd60072bc071e7"
    sha256 cellar: :any_skip_relocation, ventura:       "dfec5672d766fd6a9f96fdd25ab8a6dff5be86aab8bbd747de0d73ffdb4916b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c61a8b8c60db557c3da80e3632f122bec10ed577b756f83ea50f4cda28a09ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8c263964988f5872d5ac349b3605098a5ac5b237263865c8d4c9b89ab7de30"
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
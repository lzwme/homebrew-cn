class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "c5dcbadf3ee569c85c8481e785200270f7203d79a6c30617256bd55bb412f983"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "892a18bacdb5f4b603ec1bdd04028e67d9dd05c63427b347fc05c5994285c7a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6767da00199fd3b44bdb76f3ff74b9146857d5141201a458dda03dfe6da28463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6b12b1d8f0afec99267b0f648c76886c306dcc3ae6b2476683708f50a0691fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b1051333e2a447da354ec6523a8af52e5251995f9bab5f32b3bc2e6c346d5561"
    sha256 cellar: :any,                 arm64_linux:       "942b3cfa000bc593c2d4385e54b924c10c5830ab4fb6255d9920de457ae2640f"
    sha256 cellar: :any,                 x86_64_linux:      "46fcc5467d1cdc7c0a6d40a9468ff066b2d8b0d6bc26ebe7622ecb13442e81ee"
  end

  depends_on "rust" => :build

  resource "typeshed" do
    url "https://ghfast.top/https://github.com/python/typeshed/archive/aaefc85a95431045b0726b297d0ad1f4786ba1e2.tar.gz"
    version "aaefc85a95431045b0726b297d0ad1f4786ba1e2"
    sha256 "46980e94b26f9653d50ac6d1fc3d5a5f58fc90bb3f1b6517d9ca51ec381a71ae"

    livecheck do
      url "https://api.github.com/repos/zubanls/zuban/contents/third_party/typeshed?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"third_party/typeshed").install resource("typeshed")

    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end
class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "3f2241835ea59f3ddef29feb11f8576f6737bc02a92d4c2347078bfe52b7041b"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8881d85f8561fb03bbadff7b4d8ffa6f00f2c0fc3813b8770c3e782534d00bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de9af8ed5c5aa331cf8b6aff3d0c41f4de9a5552e1563f5b244de5c072e423a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e461f306924f94312613c25a339defd93675b2d07ddd498e7a99ae16169de9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7c21581a284fdaa9eac46c42df4418da956e0a0617b5b2f049d04d092f7430"
    sha256 cellar: :any,                 arm64_linux:   "109738d18225b3bd4a25cf9898bd1df00a6776ed4566bde620ec84fcca5b178c"
    sha256 cellar: :any,                 x86_64_linux:  "b04d8c10b6b24558a9f5d3f055f9d9abf50d89f21f2417ef462fe0839b38236e"
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
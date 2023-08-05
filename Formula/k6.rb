class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://ghproxy.com/https://github.com/grafana/k6/archive/v0.45.1.tar.gz"
  sha256 "1e1f3bb82345dc239a896841b64b54e44c9eac7b5673cd946f30f757cd920860"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ea967ac19cf0c4e8648ed42e9ed9147c909ca70d091284bcc5dcbd80741164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ea967ac19cf0c4e8648ed42e9ed9147c909ca70d091284bcc5dcbd80741164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5073e8ea75580078ed2c5e42dc1086572c476c807692652c140028da7e4ac6dc"
    sha256 cellar: :any_skip_relocation, ventura:        "6d6a94e7fa6e54fc615db8cd9db9d97d7ae3a4ad9d9c6f127ec71c6daa76c8c8"
    sha256 cellar: :any_skip_relocation, monterey:       "6d6a94e7fa6e54fc615db8cd9db9d97d7ae3a4ad9d9c6f127ec71c6daa76c8c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0679b539e8ef4bad47c291599d6ce5a0e3e7b1657976ed14bce332307196281a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d29f9e98fa489c4fcb424642d87301fe249b676391fb68a8c293c0c9c781282"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
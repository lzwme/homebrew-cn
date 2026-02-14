class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "dbc641e04f695e1eaf92722dc887bdf89c458eab2900f6516779362c84e9c8b8"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f58fc06eb7d53798367db2d91250f4be6c37fa9e34507637ddd29f8c31dd8ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c3d39210da982eb05fd40fbb3c96a170ff4946b3947cf456ef3f9362d9451d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d72202a0ed66f45e94a8a9c6307fca3a8a51f08f52e33d2629a719ea341fb24"
    sha256 cellar: :any_skip_relocation, sonoma:        "143b5c8d409f6589234edb59123af8f4e27e84a5450e637f3030393456f581fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f68ab978c9b23906d5101d0cd8dda90b74832fd8e6cefba4c2500879365114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddfd06aaf31c73a9c48c4c58e4527289eba0048e8f2c6ee1246a07508ae98166"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
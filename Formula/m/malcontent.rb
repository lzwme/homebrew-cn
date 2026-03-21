class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "35049c542ec59465d954fbfc6804d0c894b25ee4724bc361c4154e31a07d99ec"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b5cd29bc4987a0d023a995985ef070b130a04ebaa553f9e8bf8d8e65421298a"
    sha256 cellar: :any,                 arm64_sequoia: "d909722977692da781980e9ba4177feaa4e31b3d64768572432a9e897995553f"
    sha256 cellar: :any,                 arm64_sonoma:  "2afba705b8175258be84e110ab80d4caa31b903df1a1357233bae0f608280a90"
    sha256 cellar: :any,                 sonoma:        "f7a0cff0ddae276f2a32a5eddc9c509c482836d927afd847fbda84982254947b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68f6f13cb76f0053ffd8ef2b115462484d085bbd59fb215ad4a2acdde485dc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544c72be62683766432dfab17d59afb3032d890971f9ce080f15a8031ace171f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
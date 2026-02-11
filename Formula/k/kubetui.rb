class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://ghfast.top/https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "d741a0ba3eed72916986747528dda2d4f2d8d91b9bcf920bf5113f057eb79090"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80c2412f76c162fb865e7278d5693e5fe4dd77a6d875bc7dcae923ebcdf7dd75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ef06a4a39f662a7e4133e5f02744e63099e03e4cb4464ebbbc72e0555b8f24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67120239032a282765dd748a98799502f8099b953ca0c4d0c012467e5d8fa884"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b50cacdb96f2f339e923ac9fe425c75a0707985e346901b859209866c72c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266e578dfa32479614cec03d4bd3fc0fcac156485aa9f3e752cf5dd4f473532c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15305425a6559c83d665be12ae5f0d205fcf90e1d56074fd5636eef10f2452fb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kubetui", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}/kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
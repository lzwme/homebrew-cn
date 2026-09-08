class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "503a778251af707b830c328f3cdbf8eaed0197b5cfd39c8ee9671c6150a56351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c492ffb5700ab8d332db554456d4b95aa47f75cc467c13e4408310f119f24c94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e84c5bd132e593c9c75817d7377c5037dfa39729df32d984c6750089e3bb29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c33e48a31a575d88ca7593c51698ac2cfeed4694ea26e8b57da487467e68f9f"
    sha256 cellar: :any,                 arm64_linux:   "1515dc224f0f14f3c5859524afeac6d2246b2baa9f24b494b9fc9a3aeb522b91"
    sha256 cellar: :any,                 x86_64_linux:  "43a5d6c6d95af64ed60c6babea70dea22b8e04834340217883ea9d05dbdb06a6"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
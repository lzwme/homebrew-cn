class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://ghfast.top/https://github.com/semihalev/sdns/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "00e004699d0fc0051f628a51d7fc4d975e365bd35bd74969b4704718067b27af"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79b7f033d737d15c08bae2a5dc811b91147320c1e73baa1bd7b7938b144161d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d57c654d872b84f816388293575f03fbde0702ea29ab0d61235f2018fe6253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b53935a2381a41f0e7ba43e50d5cecda0ec0789c1669ca831d4ec4c45b70d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d15c4379140353003a7fa3db3b3ac0f593316d2f62140e5992a2ed680e47638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67727167be0f4a3e48a12ce741dc6b49e45af0aea5ba2992829584bed48b6caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f134a90e643d7b9f3b4aa9aa90f342cde820514cc06f930ac42434d427b762"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin/"sdns", "--config", testpath/"sdns.conf"
    sleep 2
    assert_path_exists testpath/"sdns.conf"
  end
end
class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https:sdns.dev"
  url "https:github.comsemihalevsdnsarchiverefstagsv1.5.3.tar.gz"
  sha256 "83b82288a59eaa8f52cb2fa0e2461d2a3640083a140dadfb0ae212467abdd6a7"
  license "MIT"
  head "https:github.comsemihalevsdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a650f4202675e05a17c37c5a186151d03ab3187dbe4d6590b171e72010ab6dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e12ff151cabfbaba21bd08912c8d4eeb061690440fecb08abad5b86fb1451a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cfc00a7fd030b7a63ff74a1e823e29c36d8deb016c1ec3e2b5d73ab03a5d4e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8efb2fa8f57f66e7fd032776e1a3c45749a9da6bd0c6c20cf581e7e59cfec95e"
    sha256 cellar: :any_skip_relocation, ventura:       "30c76c36501f9ff9ad1a290d86dd6cab89cfc9d87e91b1c5b519eb0ab98d84a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46b89266cd6513ae4c98443d9287e887aaa2976a2c57c9fd527d40839e1032d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf2caabcf3907d8967128086978db12758bddd9a06d447f1f91a81980d8ae08"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin"sdns", "--config", etc"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var"logsdns.log"
    log_path var"logsdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin"sdns", "--config", testpath"sdns.conf"
    sleep 2
    assert_path_exists testpath"sdns.conf"
  end
end
class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "740df1ea6f27834d52b71af5d5693bbc3af0ee65e36e175509c18ef5196c4ce4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f4fa2684e68d395c24f1b36858ebd34ea22f816df454dcb5e17c25991a5f869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f4fa2684e68d395c24f1b36858ebd34ea22f816df454dcb5e17c25991a5f869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4fa2684e68d395c24f1b36858ebd34ea22f816df454dcb5e17c25991a5f869"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1c6fa133c20ea54023d529de175886fb2b3134d3c8790ecc6621b5caf19713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b7bca8c562913367e8d19541211184c9aa7e1bd5a7b76ef2f992cc3e6d150a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37c3b1e14a056837e65d67a127b798583af3ff6dc5e8aa6f4fed7392264451d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
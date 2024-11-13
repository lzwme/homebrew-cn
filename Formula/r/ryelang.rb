class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.30.tar.gz"
  sha256 "24b86a2feae9fb5887f3179de7891a5015ff142c64a08644ab9f0fd7251beca9"
  license "Apache-2.0"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2477d5dcafb3172d7f58fc5bf992749d77ad0adf88610f47a1767613032309c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97b1cf0d156b44cd88194509fc362e38cf9bfe8a7577be78c58d7dd11714cb1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48c4066784b2366f094c607790c0e032520f6941b0b0f6513761db487220e31c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c77c58e9fdd86c531511735313d08e98f1ec64add656b30d71deed9f4816d7d6"
    sha256 cellar: :any_skip_relocation, ventura:       "7d4096af96527d4e69f14694344df55a7a90ea221cbca0b32a009f368c5a0c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2cf56f6ed477bc3f78eb663e3cfc2afb7a0bdb391efe70f0ccaae9ebb0248c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath"hello.rye", :exist?
    output = shell_output("#{bin}ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
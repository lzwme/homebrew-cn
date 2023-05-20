class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://ghproxy.com/https://github.com/rcoh/angle-grinder/archive/v0.19.1.tar.gz"
  sha256 "d2273df2b2eb9845aedaa5476d7c8a90e01c3a0d33f1b11cd33153c5d3ebf3aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60e52690fb7648ebf798215d592d78dba78736df5dfc9e090634e83db268843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "468ec6a9577069f2acf8f0f46af07189f50b72eedbb1e6e05a43ccff31edb564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c26325c93dcc4ddaf4ddcbbabd54e2b671b2ff0197b22be879e83b86d62abe4"
    sha256 cellar: :any_skip_relocation, ventura:        "91a94e9ab13845937a2335d5596a62166c091c8350b267e4da1f558719f4eb3e"
    sha256 cellar: :any_skip_relocation, monterey:       "947b4de057bc5f5693371fc4aeab357fb36460e9f0c37b6f262f473a2ceecaad"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b5e5ab8fbdfbab7dedc24440fbc6f9fd3846455f5f5820966c2c0ff7810b76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfef8b8578865bac1f26b52faf895b1153705c3cd4ccc90fc71a847e2a37215"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
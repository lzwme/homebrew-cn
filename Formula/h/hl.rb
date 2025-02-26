class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https:github.compamburushl"
  url "https:github.compamburushlarchiverefstagsv0.30.3.tar.gz"
  sha256 "184011987aa1b3a76a322364bcf44219633ef8f388db57eb4693f64139f0db3b"
  license "MIT"
  head "https:github.compamburushl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39332d35ab08653903415ae2b25fe088a27140e04969c35e19838a0de765c0a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43115f00e90c0ac5d2d8605b21672af88c623ed02360f1e860cddee411603a86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1416f08345ffbfab6aced24fc76729ce8f8ddebfa32ef667352eeb5a002546d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "52aaaccf683665e46f04941533b01163374a1adb29ddf75153f3beb4e42d006b"
    sha256 cellar: :any_skip_relocation, ventura:       "690cf05f187a31395a766e9575e51c6099ca87c3834278aec7940606e9d07fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa756318e65f2f492eaab6fb9e1371b055bbd85e91d6b850c4d551ceb5bfa27"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"hl", "--shell-completions")
    (man1"hl.1").write Utils.safe_popen_read(bin"hl", "--man-page")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hl --version")

    (testpath"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 │ERR│ An error occurred", output.chomp
  end
end
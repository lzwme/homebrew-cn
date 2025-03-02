class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https:github.compamburushl"
  url "https:github.compamburushlarchiverefstagsv0.30.4.tar.gz"
  sha256 "b32769af62391a55e04f0074ab36662307deecabca3df8e5fab70ec84b3bb367"
  license "MIT"
  head "https:github.compamburushl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61dbbd38bd14f245fb4d7ff0c11242a65facf2509d13acc2778c8c94af833ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b1ef208836da9046fe46c318a982245f795862157179deded25e9968db3d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abb9ebc3a9c7dcaa07f84644f75e71f9d07f624925d721a97afebcee7231b8f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3c402a8dbe81c7046d8c6a6df031abdcb5780ee23b8ada1b4b2fc53a2f8e47"
    sha256 cellar: :any_skip_relocation, ventura:       "96a7f95cafd8fd3bef142a8e1a458dbfc41e829a0474b1e999a129f5e5b51b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fee1ae71a1f2b45035734bb20abd1e9aa5cf774467d9dcb42f159de33764dce"
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
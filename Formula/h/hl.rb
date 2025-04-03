class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https:github.compamburushl"
  url "https:github.compamburushlarchiverefstagsv0.31.0.tar.gz"
  sha256 "929e47639e448b2bdbaac75406e44db183f2d9a34e9882ccd7bc87119cc0db6b"
  license "MIT"
  head "https:github.compamburushl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ada1977851872b72d6b675429f93e60b865a3f2e6574ad83f880646cc8164af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "881473d61406cce34a5211bdfe553b3618dad5f2b0496888f0216e9d9512482a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c5a1ae4314cc8cd552e7f360f95c0cbab0ecef14637e6c28baba4230a599132"
    sha256 cellar: :any_skip_relocation, sonoma:        "37b9f75bd4b292a81dc688968594d52b3a4ebef3f89684b7939134683e77cfc1"
    sha256 cellar: :any_skip_relocation, ventura:       "fbf4fd18892d6680f6cc6fde65326cd2f7abc0de60a913bce1d86b352edd0ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9333accf7254b25f1baf3f591cb3f6d6f68b44abe1e4b629cc50abf30e85223e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2af4ae3a564fc436ff3ff45ae0271e1f6aa787c8ef7ec7a0c7c669ab3266657"
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
    assert_equal "Feb 17 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
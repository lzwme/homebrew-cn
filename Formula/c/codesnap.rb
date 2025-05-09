class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.12.4.tar.gz"
  sha256 "33ef4168ce1aa589b6f1454242fa079bb8f69fabc7baf58313064c6554608438"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f8bc31a0f0679316140653209b7cca185135949c5e8ada455c8104da4020be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7240fcf2a191496282de4d306d0e3b12a3775a55655d05617a69ea4b7ff4f0a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63784447a6eb54b3b2f6d4a0dd1fc6cbd63a7f274c98d7795f85366b0db391fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb27002943f155d83f71c0abe3468f7a986f3487e6dee80a9f2beaa470ae5e92"
    sha256 cellar: :any_skip_relocation, ventura:       "eb73ec874cd1908a5a6d0760c4919d22f3e8d8b80cbb03fffd8e67df2458a71c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e4e6dbd4152640ab4a714358fb2c54027c06bd9217f98f4f0482603ba45f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5749a3735d20ea7d7156f19ad545e1d45cb374f698942e642fe384ca2c279510"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end
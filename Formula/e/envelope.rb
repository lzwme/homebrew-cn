class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https:github.commattrighettienvelope"
  url "https:github.commattrighettienvelopearchiverefstags0.4.0.tar.gz"
  sha256 "f855ecc19d5508bb4d08181d4e7c6d87f52faedf066299722056afe14b07b66d"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.commattrighettienvelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97769996b52b7dfb3d4dc879f1decb372b7bfb6a7987d5c65d9de8da7535ad30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13e878c3298859c728acbbe8d194f7e8ca1d1e5d4f0f8c48f0f82d022dd5563"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9e3e5f20142d839375290206505376207918d02934f7d2c3e8ce94501421da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "70634e1d40b81b499516c7e5ef642671d59c6d43937b1431e9c0cf3a8c2614e2"
    sha256 cellar: :any_skip_relocation, ventura:       "20a95fa5a7496e2c130f390c76af8f6685263e6cd64f7bdf4b5337c0ca211787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62ee614d6e26134758eaa05d737f02ec24ebd2953171f67dcf268f8bbd4b4d4"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "manenvelope.1.md", "-o", "envelope.1"
    man1.install "envelope.1"
  end

  test do
    assert_equal "envelope #{version}", shell_output("#{bin}envelope --version").strip

    assert_match "error: envelope is not initialized in current directory",
      shell_output("#{bin}envelope list 2>&1", 1)

    system bin"envelope", "init"
    system bin"envelope", "add", "dev", "var1", "test1"
    system bin"envelope", "add", "dev", "var2", "test2"
    system bin"envelope", "add", "prod", "var1", "test1"
    system bin"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}envelope list")
  end
end
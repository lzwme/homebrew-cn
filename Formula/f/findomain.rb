class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://ghproxy.com/https://github.com/Findomain/Findomain/archive/refs/tags/9.0.3.tar.gz"
  sha256 "7ac191d5d7c3f7cb9fc74750f9cba3963f77dba5edcf84965d55f887b21f3d0e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c25937053c35b80a1bcce27b6bf136d993f344b8b7ab9c55e0088a57d20bc89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe41a854a6f1de8a6af33ee04ca537496c96c32c7730d83aebfa96b8ddd4287"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "953cf29f67076ff1020986d851adab8c8ac90c74cc5ab1beb0dd515036396b34"
    sha256 cellar: :any_skip_relocation, sonoma:         "e895134a22456d2657717a50d291317f75cf573acd0eebd18fd2f8d4230dd768"
    sha256 cellar: :any_skip_relocation, ventura:        "e65fe4ddfe88769e6c1a0a0239034536a7deb18969b59d2ea1870749efc53212"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8f820f034dd8f1b7973e0273c35e86d0f771319ca82bb140f1f6e7bcb0c5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1117429f919281c223780f672305dd545fe34efe5988a5c48462b45b6ba7253"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
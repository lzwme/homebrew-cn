class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.22.6.tar.gz"
  sha256 "c50d7e025b50c828ebf71e8393eec4c177a2cf727940478a4d8af17ff1b0ac49"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b50c7557283e9a57c264cdaaaa3d43729d08c86827c908ad988d428428740435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472bc6077fb2048b30c5d5de76d0bc2682f07dc229de158e472fe85ce80bcb82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d524487e009babb919299e2474416b2f186f2feaadff1652fa332c52bf7f55d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "99848f8c1e25d6f12b665ced4a9ec1ad0b710bbefa3d82c489e228391187e323"
    sha256 cellar: :any_skip_relocation, ventura:       "473b110809a5e155fd202e78aa5fc9423ef53ecdb723b97256a56504cace9272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989f923cfaf42716b651ac32c155e23f81204a40b155c5c8abbb3c80a6d14b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43248f46184d599d8e799ae7fa8afe69473bb46580f0ee5fe6ef91b7f6648e59"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end
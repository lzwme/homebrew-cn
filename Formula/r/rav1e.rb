class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https:github.comxiphrav1e"
  license "BSD-2-Clause"
  head "https:github.comxiphrav1e.git", branch: "master"

  stable do
    url "https:github.comxiphrav1earchiverefstagsv0.7.0.tar.gz"
    sha256 "dd6c4b771d985f547787383f5d77bc124ac406d574a308a897da9642410c1855"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https:github.comxiphrav1ereleasesdownloadv0.7.0Cargo.lock"
      sha256 "2c5b50b978cc1e8cddd898c226276100419953ff9e0bafc5b02fbdb67a9dd346"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89a6defda3ed9f7d8da30ba2eece54650748b01cca5b0de4c7a77b069db370c5"
    sha256 cellar: :any,                 arm64_ventura:  "545dc6b769dc3af92c6315b9661c9fdcb11e8df23827847595c798f2a48096a1"
    sha256 cellar: :any,                 arm64_monterey: "f16c710d862b9714ab2ae847ec5f84518ee531cc8a24866264c2bbdb0d62a71e"
    sha256 cellar: :any,                 sonoma:         "2a7d52de12804cbd463e97cf15885806cde8036f9431e6a7f2da453c73afb8b6"
    sha256 cellar: :any,                 ventura:        "9d04d1b7123391c874dacc8b7b64e1a9a9562eea72dfe78ddd773aca6d05601d"
    sha256 cellar: :any,                 monterey:       "d6f211aeb4864d3d1635add895731099cfb2a775e165213bd5d6e94cfb9b250b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fbf882781283b1cd9e6eb9b5875e8ab9623db041dd1b9bf08bd2e39799288b"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-bus_qcif_7.5fps.y4m" do
    url "https:media.xiph.orgvideoderfy4mbus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    buildpath.install resource("Cargo.lock") if build.stable?
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    assert_equal version, resource("Cargo.lock").version, "`Cargo.lock` resource needs updating!" unless head?
    resource("homebrew-bus_qcif_7.5fps.y4m").stage do
      system bin"rav1e", "--tile-rows=2",
                          "bus_qcif_7.5fps.y4m",
                          "--output=bus_qcif_15fps.ivf"
    end
  end
end
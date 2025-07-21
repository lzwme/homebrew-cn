class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://ghfast.top/https://github.com/yaa110/nomino/archive/refs/tags/1.6.2.tar.gz"
  sha256 "bf76dfc714da1340e2b5da14a01aaec801cc42ea8b94e06df57c6bd0e0527b1f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866202de753f201013da5a796d97505e3cc5bfd229cfcda11f5ba165984cf771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4618d2d23ec7109b98cacf05317a3d5645b0031d8365c096beb1463484d0a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a649f54f87fe7ab0d8397bbe027662a2beac791f0d59cb8beaf68e7fd814c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c0cb658043c278e1090910bdbf1bb2a219212e3acfa03008d66cb0151eed159"
    sha256 cellar: :any_skip_relocation, ventura:       "eb3d45e5e7c37b6ef143c4808a2dde6a522b222dfd35b0dde6fba2d5387ba037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ee605344d8ead1aad5be0c869ab075ed9d7c3808993a21cb2615b777061334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65573ceff4aa613feded04c688ae6f22e7201e5729cc058ab74760ee11406e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_path_exists testpath/"Homebrew-#{n}.txt"
    end
  end
end
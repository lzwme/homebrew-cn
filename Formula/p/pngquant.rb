class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https:pngquant.org"
  url "https:static.crates.iocratespngquantpngquant-3.0.2.crate"
  sha256 "33f8501d8b81f34cb6f028a5d06772b9d7940e0bc2b15a5d0bce138cb74233cb"
  license :cannot_represent
  head "https:github.comkornelskipngquant.git", branch: "main"

  livecheck do
    url "https:crates.ioapiv1cratespngquantversions"
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :json do |json|
      json["versions"]&.map do |version|
        next if version["yanked"] == true
        next if (match = version["num"]&.match(regex)).blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dcb677c4bffb533a7a5c70e52977b0923bdce6bebc232bb3880cf113b823bf17"
    sha256 cellar: :any,                 arm64_ventura:  "ec8a1fb6c4e95afd713c5fbde9fc67513eb9f1525afa82fa250ac0c1219273f8"
    sha256 cellar: :any,                 arm64_monterey: "0123b2f1143791189367c1714f1d20d89bbb385f0fb5497b857fc0bf65701ec7"
    sha256 cellar: :any,                 sonoma:         "37928ca3e06ec9a90747b3a9cb139381a0dab1648c31b364ecda5fd820a46e14"
    sha256 cellar: :any,                 ventura:        "60970346fd1f5cdc306045c4740824a58c47f2dbea18e2ff4411cade6e857679"
    sha256 cellar: :any,                 monterey:       "c82b3ec91aa752a17bcebda7bc36e40006e53f84ea5a024193a96d10ab3db435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ea8f69b63a235f33a839e3095dbc8b03080c2f3ab75bee6c55b741aa7c27cb1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "tar", "--strip-components", "1", "-xzvf", "pngquant-#{version}.crate"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath"out.png", :exist?
  end
end
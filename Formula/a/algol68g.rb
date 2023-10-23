class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.3.tar.gz"
  sha256 "df228a60bc7503defe6664c807f6d7fbd896490f090ae150d90c24b2de196553"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4fb15cbf0bfe5ca7fb7115b15d8d756c738c9b3f423b8fbc09432a67e465e522"
    sha256 arm64_ventura:  "4ab5d00bae3ca84d3dbfc442b3592e5ee82af4c536527bfc28b43e06a03faf7a"
    sha256 arm64_monterey: "b3a4af4f606a11798a21f01c803260ac41fafec36e98b4616a723217373783c1"
    sha256 sonoma:         "987bf3dfb930a4e75c0434129caa03b70d893c7b23f84b2f8a8de9bde6b15510"
    sha256 ventura:        "d29c767cac90b94a09e97c329319980212816d9f3f8f189504bc7b9e5f8bc484"
    sha256 monterey:       "1c8b6dae11a47a1e8efec2219d7c3fd8603957b9d0305e1776621d209e5c181e"
    sha256 x86_64_linux:   "dccf1f9a0259742385ff00b9876d6dec38bfd87287aace025fea0b9e2e181699"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
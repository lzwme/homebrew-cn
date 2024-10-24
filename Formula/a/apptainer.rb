class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https:apptainer.org"
  url "https:github.comapptainerapptainerreleasesdownloadv1.3.4apptainer-1.3.4.tar.gz"
  sha256 "c6ccfdd7c967e5c36dde8711f369c4ac669a16632b79fa0dcaf7e772b7a47397"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9f19af1d189f432345055e8c68ab8b07408d6925ff399faaa95c3d226ed98712"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release-stripped
      -v
    ]
    ENV.O0
    system ".mconfig", *args
    cd ".builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match(There are [0-9]+ container file, shell_output("#{bin}apptainer cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library:alpine cat etcalpine-release
  end
end
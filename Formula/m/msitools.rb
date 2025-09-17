class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.106/msitools-0.106.tar.xz"
  sha256 "1ed34279cf8080f14f1b8f10e649474125492a089912e7ca70e59dfa2e5a659b"
  license "LGPL-2.1-or-later"

  # msitools doesn't seem to use the GNOME version scheme, so we have to
  # loosen the default `Gnome` strategy regex to match the latest version.
  livecheck do
    url :stable
    regex(/msitools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ea1afd46d27a15b86175c1e085f383237cf7dde567e54fc07bfed1b896649e6e"
    sha256 arm64_sequoia: "12fe70c934de768f9374ebeedaf658c477dbdb3ab0f0a96dd3baf66101c0083d"
    sha256 arm64_sonoma:  "efa74fbc638ff57c0af2e6036eedbde4c5ba367b25099bcfb7983abe29891d0a"
    sha256 arm64_ventura: "b44ed9f4798de3add43ba4b2d4eab8d19de501e6550f33bb14a70cd929ae4e7b"
    sha256 sonoma:        "828f74c79ab546bff9163b165e186f9a071593ac7ef94b8980ae1295a64ec2eb"
    sha256 ventura:       "9643bfd74e73e44cb051d236b2ad71ec2ffe7f45a7466ecb44758b6909c91cbd"
    sha256 arm64_linux:   "dbe166925d6bcfe474984d3514b2145e151ea0e3953beb76410f76a052f29d62"
    sha256 x86_64_linux:  "6361381386fa074d2bed5ced54c6ffac0902bd01add061c47b7a35b603c0757d"
  end

  depends_on "bison" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "gcab"
  depends_on "glib"
  depends_on "libgsf"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dintrospection=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # wixl-heat: make an xml fragment
    assert_match "<Fragment>", pipe_output("#{bin}/wixl-heat --prefix test", nil, 0)

    # wixl: build two installers
    1.upto(2) do |i|
      (testpath/"test#{i}.txt").write "abc"
      (testpath/"installer#{i}.wxs").write <<~XML
        <?xml version="1.0"?>
        <Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
           <Product Id="*" UpgradeCode="DADAA9FC-54F7-4977-9EA1-8BDF6DC73C7#{i}"
                    Name="Test" Version="1.0.0" Manufacturer="BigCo" Language="1033">
              <Package InstallerVersion="200" Compressed="yes" Comments="Windows Installer Package"/>
              <Media Id="1" Cabinet="product.cab" EmbedCab="yes"/>

              <Directory Id="TARGETDIR" Name="SourceDir">
                 <Directory Id="ProgramFilesFolder">
                    <Directory Id="INSTALLDIR" Name="test">
                       <Component Id="ApplicationFiles" Guid="52028951-5A2A-4FB6-B8B2-73EF49B320F#{i}">
                          <File Id="ApplicationFile1" Source="test#{i}.txt"/>
                       </Component>
                    </Directory>
                 </Directory>
              </Directory>

              <Feature Id="DefaultFeature" Level="1">
                 <ComponentRef Id="ApplicationFiles"/>
              </Feature>
           </Product>
        </Wix>
      XML
      system bin/"wixl", "-o", "installer#{i}.msi", "installer#{i}.wxs"
      assert_path_exists testpath/"installer#{i}.msi"
    end

    # msidiff: diff two installers
    lines = shell_output("#{bin}/msidiff --list installer1.msi installer2.msi 2>/dev/null").split("\n")
    assert_equal "-Program Files/test/test1.txt", lines[-2]
    assert_equal "+Program Files/test/test2.txt", lines[-1]

    # msiinfo: show info for an installer
    out = shell_output("#{bin}/msiinfo suminfo installer1.msi")
    assert_match(/Author: BigCo/, out)

    # msiextract: extract files from an installer
    mkdir "files"
    system bin/"msiextract", "--directory", "files", "installer1.msi"
    assert_equal (testpath/"test1.txt").read,
                 (testpath/"files/Program Files/test/test1.txt").read

    # msidump: dump tables from an installer
    mkdir "idt"
    system bin/"msidump", "--directory", "idt", "installer1.msi"
    assert_path_exists testpath/"idt/File.idt"

    # msibuild: replace a table in an installer
    system bin/"msibuild", "installer1.msi", "-i", "idt/File.idt"
  end
end
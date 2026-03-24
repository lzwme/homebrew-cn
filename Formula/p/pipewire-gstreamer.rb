class PipewireGstreamer < Formula
  desc "GStreamer Plugin for PipeWire"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.2/pipewire-1.6.2.tar.gz"
  sha256 "2014c187fccdd6d245585be4eda7dabd781dcddd921604c40ab015bba6cb042d"
  license "MIT"
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  livecheck do
    formula "pipewire"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ee4e435ed86521beb4b421b9e6781a00982dae23a6de7747fdb55ab1639a5530"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "154f32dce5a913be0bfac715017398d15fe38f97db96bad129dbd6d941be280b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gstreamer"
  depends_on :linux
  depends_on "pipewire"

  def install
    args = %W[
      -Dexamples=disabled
      -Dgstreamer=enabled
      -Dgstreamer-device-provider=enabled
      -Dsession-managers=[]
      -Dsysconfdir=#{etc}
      -Dtests=disabled
      -Dudevrulesdir=#{lib}/udev/rules.d
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose", "gstpipewire"
    (lib/"gstreamer-1.0").install "build/src/gst/libgstpipewire.so"
  end

  def caveats
    <<~EOS
      For GStreamer to find the bundled plugin:
        export GST_PLUGIN_PATH=#{opt_lib}/gstreamer-1.0
    EOS
  end

  test do
    ENV["GST_PLUGIN_PATH"] = opt_lib/"gstreamer-1.0"
    assert_match "pipewiresink: PipeWire sink", shell_output("#{Formula["gstreamer"].bin}/gst-inspect-1.0 pipewire")
  end
end
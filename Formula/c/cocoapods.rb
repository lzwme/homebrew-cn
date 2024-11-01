class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https:cocoapods.org"
  url "https:github.comCocoaPodsCocoaPodsarchiverefstags1.16.2.tar.gz"
  sha256 "3067f21a0025aedb5869c7080b6c4b3fa55d397b94fadc8c3037a28a6cee274c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68781e12612d0cfa292ad6e983a2711fcba61c31ff4f2cdfd01cfb80be2dfae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68781e12612d0cfa292ad6e983a2711fcba61c31ff4f2cdfd01cfb80be2dfae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68781e12612d0cfa292ad6e983a2711fcba61c31ff4f2cdfd01cfb80be2dfae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d1c33409214e70141aec16e250de82ad06d3c3a6c388c125195c6488bcf3e2f"
    sha256 cellar: :any_skip_relocation, ventura:       "3d1c33409214e70141aec16e250de82ad06d3c3a6c388c125195c6488bcf3e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a2e96d3ec4bb17a007ae9c78efda0942905dfc353113e331e967cc12f8f680"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec"binpod", libexec"binxcodeproj"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin"pod", "list"
  end
end
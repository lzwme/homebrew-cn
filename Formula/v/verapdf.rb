class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.125.tar.gz"
  sha256 "dad9ce59c9c4aee6f015ac118dc98cc8145c101b09c7bc05fd4be66fab47fca2"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fa8540381a8d96a050fb3f0ebe15e9ea15316ac8d4abed2a8fc25227f1cf9a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2288f9e1bf6d79474798bb3391e69098847f03780a34135a6ea1b594ef81e731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e20f2e63aae2780c1f70a549aa30c475b08bf84d1a53be117601a0303fe070"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3b961f7227055c1bc0144e617138beb872b146efb6db54733226603a27f761e"
    sha256 cellar: :any_skip_relocation, ventura:        "f91851508e0a812b3c194609deae29b4038238f26eb4b4774c0292117d985e36"
    sha256 cellar: :any_skip_relocation, monterey:       "799cf66c14231e4584444d58cf6d675454f5c8b5093a9c8ffcb07be2fdfbda58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b32c69860950447d1f36256ad69b2a1552d17ef4c57f59a3a717f83d9e908ae"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
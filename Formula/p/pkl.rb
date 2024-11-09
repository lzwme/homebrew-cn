class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https:pkl-lang.org"
  url "https:github.comapplepklarchiverefstags0.27.0.tar.gz"
  sha256 "d8ea363bf14567ba76e8a3b43ee47d8280d66734a3c52e854578c03b797b348d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb40b24e497afd5aca770b24dbc74f1156be3a053edde72aa4854b09edd9c134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48bd708c5fe637606bccc6620f69a4848e54389ae62ac52d7c3bcf0126c246ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d3054003f643b5f2d320f8d93b670e989778f10891d751a0b220247884aa5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "190fbf71d76887fd76fbba991fe774d70c2117c5be45d1fd3f8284c696a081f5"
    sha256 cellar: :any_skip_relocation, ventura:       "eff98468e283f7933dd35b43d7f24c49902c64cc931c3d50adcf70c947bd1f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cebeb8241da7ba7e1e194aa199d48150613cd7d24792349e0a4b2e32dd288c58"
  end

  depends_on "gradle" => :build
  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system "gradle", "--no-daemon", "-DreleaseBuild=true", job_name
    bin.install "pkl-clibuildexecutablepkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}pkl --version")
  end
end
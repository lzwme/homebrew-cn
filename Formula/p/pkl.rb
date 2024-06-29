class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https:pkl-lang.org"
  url "https:github.comapplepklarchiverefstags0.26.1.tar.gz"
  sha256 "a97d15c200c042dbc064726a773cb533e52cd608de317347de8617a0661d07ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbfc9a419712873503965e7114765022ca8a152a13a4bbc43f4968d3a7f22f53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "624cc6cb59910d2831760b1df251bb587e54fa636883ebf9cc3a385720e37cb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e5f30519896cb854b646242b1c46cdbfcd9f4eebc8aa41450fbfabaae8e872f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f472b74588437d38e6c02b82592caf05ea5edb8a21c784b72d1b5d6050c08f53"
    sha256 cellar: :any_skip_relocation, ventura:        "77a7dbd1ef6be9444c3239cf4b56b854705b2bd67f60cd8d8582239a4acc6a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "4c97a8d6647eb614233799529ecdb473b9ae6760f559eea0157abe2c29fa1030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b59a6831782eddad29748958f497e041fdd38d036027b15aafb14be5eb15f00"
  end

  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    # Need to set this so that native-image passes through env vars when calling out to the C toolchain.
    ENV["NATIVE_IMAGE_DEPRECATED_BUILDER_SANITATION"] = "true"

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system ".gradlew", "-DreleaseBuild=true", job_name
    bin.install "pkl-clibuildexecutablepkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}pkl --version")
  end
end
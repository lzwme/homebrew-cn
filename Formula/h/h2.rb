class H2 < Formula
  desc "Java SQL database"
  homepage "https:www.h2database.com"
  url "https:github.comh2databaseh2databasereleasesdownloadversion-2.3.230h2-2024-07-15.zip"
  version "2.3.230"
  sha256 "b53719c0b801f1f83d4f2cb2e9874116725a6d2120659a9183af1877887890c7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89ab4c6adafc53246cb073e24daba248bcf4bb5ef6cee3cf703a1021b26a485c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ab4c6adafc53246cb073e24daba248bcf4bb5ef6cee3cf703a1021b26a485c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89ab4c6adafc53246cb073e24daba248bcf4bb5ef6cee3cf703a1021b26a485c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7348c41c4b93988cb9dfbe4b2458ed928d9308b49a53883127f2b24f106fdd97"
    sha256 cellar: :any_skip_relocation, ventura:        "7348c41c4b93988cb9dfbe4b2458ed928d9308b49a53883127f2b24f106fdd97"
    sha256 cellar: :any_skip_relocation, monterey:       "89ab4c6adafc53246cb073e24daba248bcf4bb5ef6cee3cf703a1021b26a485c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05377d69788c04d8c4ad7e329f1594f53c061d5690c522d1e272d7d573bea389"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin*.bat"]

    # Fix the permissions on the script
    # upstream issue, https:github.comh2databaseh2databaseissues3254
    chmod 0755, "binh2.sh"

    libexec.install Dir["*"]
    (bin"h2").write_env_script libexec"binh2.sh", Language::Java.overridable_java_home_env
  end

  service do
    run [opt_bin"h2", "-tcp", "-web", "-pg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "Usage: java org.h2.tools.GUIConsole", shell_output("#{bin}h2 -help 2>&1")
  end
end
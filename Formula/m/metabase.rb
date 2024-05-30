class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.49.13metabase.jar"
  sha256 "3d852ab3383fceef3608b9a98f8dec6c467a1f48de728173deeacd19a6b1fa54"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1df4a11436f33c2048f945c3a8ed49d10ce33081fddf2d6283e63eedd12e683f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1df4a11436f33c2048f945c3a8ed49d10ce33081fddf2d6283e63eedd12e683f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1df4a11436f33c2048f945c3a8ed49d10ce33081fddf2d6283e63eedd12e683f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1df4a11436f33c2048f945c3a8ed49d10ce33081fddf2d6283e63eedd12e683f"
    sha256 cellar: :any_skip_relocation, ventura:        "1df4a11436f33c2048f945c3a8ed49d10ce33081fddf2d6283e63eedd12e683f"
    sha256 cellar: :any_skip_relocation, monterey:       "1df4a11436f33c2048f945c3a8ed49d10ce33081fddf2d6283e63eedd12e683f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "991665614b6ba51d31233a4fe8663c0c2df5b9c1a2fdb9da48b12272a0f4e2b2"
  end

  head do
    url "https:github.commetabasemetabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system ".binbuild"
      libexec.install "targetuberjarmetabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec"metabase.jar", "metabase"
  end

  service do
    run opt_bin"metabase"
    keep_alive true
    require_root true
    working_dir var"metabase"
    log_path var"metabaseserver.log"
    error_log_path "devnull"
  end

  test do
    system bin"metabase", "migrate", "up"
  end
end
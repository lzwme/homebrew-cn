class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.13metabase.jar"
  sha256 "57b54ebd2b60e8fc52ba332062d9130f60489aba33aa56b9e639d4ad450c815b"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caf71b44c69059b3811ac3ad6625c7cf7ee2f1713d856bd65b6a834d3d1c18b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caf71b44c69059b3811ac3ad6625c7cf7ee2f1713d856bd65b6a834d3d1c18b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf71b44c69059b3811ac3ad6625c7cf7ee2f1713d856bd65b6a834d3d1c18b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "caf71b44c69059b3811ac3ad6625c7cf7ee2f1713d856bd65b6a834d3d1c18b8"
    sha256 cellar: :any_skip_relocation, ventura:        "3303ee863dbad2582e99953f472e7abdedc08b3f4073f56e21326d9e9eee9359"
    sha256 cellar: :any_skip_relocation, monterey:       "caf71b44c69059b3811ac3ad6625c7cf7ee2f1713d856bd65b6a834d3d1c18b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62f8e61e775474179a8c9f63c81ee6a0973ed892d004817ee41526e2f0d2847"
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
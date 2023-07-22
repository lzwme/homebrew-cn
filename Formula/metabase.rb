class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.6.1/metabase.jar"
  sha256 "12d267bf515a238944bb65fceed1ef83f5ae63451c11ad5b7f7adbeaf612e5c6"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2bca290984a7c108643a6c3990ae198cdbe9dcd3effc0737b5f6c2d11e7718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2bca290984a7c108643a6c3990ae198cdbe9dcd3effc0737b5f6c2d11e7718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2bca290984a7c108643a6c3990ae198cdbe9dcd3effc0737b5f6c2d11e7718"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2bca290984a7c108643a6c3990ae198cdbe9dcd3effc0737b5f6c2d11e7718"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2bca290984a7c108643a6c3990ae198cdbe9dcd3effc0737b5f6c2d11e7718"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e2bca290984a7c108643a6c3990ae198cdbe9dcd3effc0737b5f6c2d11e7718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf23487aa45c0423b500b3c61a0db7a1b85472e56d865f33b91daef4b359aafb"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
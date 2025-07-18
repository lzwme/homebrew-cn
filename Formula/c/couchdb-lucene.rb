class CouchdbLucene < Formula
  desc "Full-text search of CouchDB documents using Lucene"
  homepage "https://github.com/rnewson/couchdb-lucene"
  url "https://ghfast.top/https://github.com/rnewson/couchdb-lucene/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "8297f786ab9ddd86239565702eb7ae8e117236781144529ed7b72a967224b700"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e51dc09d265658f719623e8e19ae3500b9e798fddb6baacbfe17f31d5ed41dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f739d9de763e66d5ccfbfb3d14034352e0d9e0c4e37799aca78487b395f029a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaa814fcca3f76e89a767b2ee41759690e5cfe7b90fac27e9b1c8be31c54126b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5729f57b791c90e176835e8ec3b21889b0a8e8b9dcd57c3e995cf377b8b0cd84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2d73a35db77da8eaed04fc2f1afb87dcc995c1f79acbae54e831c36782b286"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0bc6e1e6d57a43c6e38f9a10179104dcb080a9c1256026bfd1b6b3502ebbd2b"
    sha256 cellar: :any_skip_relocation, ventura:        "3db1128166f7c71200fcccf92414e16fc1a0f20921bd00a46460f508716aacbe"
    sha256 cellar: :any_skip_relocation, monterey:       "0bdd89c21b0a7f779e79afe8b44f816aa84a47680f78888d3ef9ca60d9bc59d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c75a95f3c1909e99602f51ed4c55fc2eb495910d8772b9b693347c633141715"
    sha256 cellar: :any_skip_relocation, catalina:       "5888b91cbf5c0fe4744ee9f1cf0ca204f9dd89e125a06fc928375b1d2770ae87"
    sha256 cellar: :any_skip_relocation, mojave:         "d7e8191c66bc938d7c8e15c10c13612be41ef601f5f6ab78b9ef5275c04bf89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d08b00d0ef852160eb6f5fef96f8cc9387b2fa4c29a792cfe9a13ccdf2d690b"
  end

  disable! date: "2024-12-13", because: :repo_archived

  depends_on "maven" => :build
  depends_on "couchdb"
  depends_on "openjdk"

  def install
    system "mvn"
    system "tar", "-xzf", "target/couchdb-lucene-#{version}-dist.tar.gz", "--strip", "1"

    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env
    env["CL_BASEDIR"] = libexec/"bin"
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      cmd = "cl_#{bin_name}"
      (bin/cmd).write_env_script libexec/"bin/#{bin_name}", env
      (libexec/"clbin").install_symlink bin/cmd => bin_name
    end

    ini_path.write(ini_file) unless ini_path.exist?
  end

  def ini_path
    etc/"couchdb/local.d/couchdb-lucene.ini"
  end

  def ini_file
    <<~EOS
      [httpd_global_handlers]
      _fti = {couch_httpd_proxy, handle_proxy_req, <<"http://127.0.0.1:5985">>}
    EOS
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix 'cl_'.

      If you really need to use these commands with their normal names, you
      can add a "clbin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/clbin:$PATH"
    EOS
  end

  service do
    run opt_bin/"cl_run"
    environment_variables HOME: "~"
    run_type :immediate
    keep_alive true
  end

  test do
    # This seems to be the easiest way to make the test play nicely in our
    # sandbox. If it works here, it'll work in the normal location though.
    cp_r Dir[opt_prefix/"*"], testpath
    inreplace "bin/cl_run", "CL_BASEDIR=\"#{libexec}/bin\"",
                            "CL_BASEDIR=\"#{testpath}/libexec/bin\""
    port = free_port
    inreplace "libexec/conf/couchdb-lucene.ini", "port=5985", "port=#{port}"

    fork do
      exec "#{testpath}/bin/cl_run"
    end
    sleep 5

    output = JSON.parse shell_output("curl --silent localhost:#{port}")
    assert_equal "Welcome", output["couchdb-lucene"]
    assert_equal version, output["version"]
  end
end
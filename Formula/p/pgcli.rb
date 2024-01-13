class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/08/a7/448bcaf13dbcb4bd00c4f62fea1b2b491958653646da41c785755df6235f/pgcli-4.0.1.tar.gz"
  sha256 "f2feea2099ce1ad5e8a9d5d93b0edaf60dc61e97b21b75e91d9723939ce53bd2"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f14ed2a232cf404aa9ec3bb7c485766cfa3463c6a58a6c484a6fa1583680b4aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1850becffb22e97b6a8a80cb94b1d38d89024265541d4d7724d25904260ea7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29ad1c8c8e5472388d76013900f054fabbc2529b7b3be27bd32e496887474f41"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1519c869a32ea09caca4c226306e0fa24dc4f889a37a4bbd7bee06dddd58272"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb358926d258a05671a2c5a6af1f10aa55a81b786618cc6fb08ee5767e797d3"
    sha256 cellar: :any_skip_relocation, monterey:       "cb1a9b0749d6024444b3bc16302831990240c828f5d1aabb6594deb995dee0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6afd7f4ea6ce3cd213a7cbffea865960092d633dfaa71a00a71ef810a2c533"
  end

  depends_on "rust" => :build # for pendulum
  depends_on "libpq"
  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "sqlparse"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/b8/fe/27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77/pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/2e/b8/52f0d19d80872df8ed2bbfc4569196e30d455d3b5f91659a6bf5c0d8e57e/pgspecial-2.1.1.tar.gz"
    sha256 "a38239cd961fac33ce6da35c466d758acb6f942901598d7df74e5b82fe6f5636"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/69/3e/ac4e466929237b5711c35ee3a1d93bd4bcfb3ad5d10b4adf86a1416f2256/psycopg-3.1.17.tar.gz"
    sha256 "437e7d7925459f21de570383e2e10542aceb3b9cb972ce957fdd3826ca47edc6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "time-machine" do
    url "https://files.pythonhosted.org/packages/48/50/d0c443bc1287dc20a22597346864175774d39f40239223f95fb03d70a044/time_machine-2.13.0.tar.gz"
    sha256 "c23b2408e3adcedec84ea1131e238f0124a5bc0e491f60d1137ad7239b37c01a"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/4d/60/acd18ca928cc20eace3497b616b6adb8ce1abc810dd4b1a22bc6bdefac92/tzdata-2023.4.tar.gz"
    sha256 "dd54c94f294765522c77399649b4fefd95522479a664a0cec87f41bebc6148c9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "psycopg" }
    venv.pip_install_and_link buildpath

    generate_completions_from_executable(bin/"pgcli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "Invalid DSNs found in the config file", shell_output("#{bin}/pgcli --list-dsn 2>&1", 1)
    (testpath/"pgclirc").write <<~EOS
      [alias_dsn]
      homebrew_dsn = postgresql://homebrew:password@localhost/dbname
    EOS
    assert_match "homebrew_dsn", shell_output("#{bin}/pgcli --pgclirc=#{testpath}/pgclirc --list-dsn")
  end
end
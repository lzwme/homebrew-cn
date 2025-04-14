class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https:lostpackets.dekhal"
  url "https:files.pythonhosted.orgpackagesce174e747ffe461fbdaefed6c703a9343c560a7316d25774aca2aa9935ffd117khal-0.12.0.tar.gz"
  sha256 "ee8a6acf1ed09265b849c1cfe51ae94b6bc693914f7e5b8e8cb5ec49b283b9bf"
  license "MIT"
  head "https:github.compimutilskhal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ad937f119cffbf8f2ffb24eed2838bb50d509a78687711a86c55fdcf3ff1c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ad937f119cffbf8f2ffb24eed2838bb50d509a78687711a86c55fdcf3ff1c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4ad937f119cffbf8f2ffb24eed2838bb50d509a78687711a86c55fdcf3ff1c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "11b937d13e507cf211953741fb459260ab91826175b4dfba97b685e04445ad7c"
    sha256 cellar: :any_skip_relocation, ventura:       "11b937d13e507cf211953741fb459260ab91826175b4dfba97b685e04445ad7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ad937f119cffbf8f2ffb24eed2838bb50d509a78687711a86c55fdcf3ff1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ad937f119cffbf8f2ffb24eed2838bb50d509a78687711a86c55fdcf3ff1c5"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "icalendar" do
    url "https:files.pythonhosted.orgpackages3cd8ada43e4872aab3bfaf2cc2e09b2d2a5d83f771bfc58ba6a63904a5067db8icalendar-5.0.13.tar.gz"
    sha256 "92799fde8cce0b61daa8383593836d1e19136e504fa1671f471f98be9b029706"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages8b2ec14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackages9821ad23c9e961b2d36d57c63686a6f86768dd945d406323fb58c84f09478530urwid-2.6.16.tar.gz"
    sha256 "93ad239939e44c385e64aa00027878b9e5c486d59e855ec8ab5b1e1adcdb32a2"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    %w[khal ikhal].each do |cmd|
      generate_completions_from_executable(bincmd, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    (testpath".calendartest01ef8547.ics").write <<~EOS
      BEGIN:VCALENDAR
      VERSION:2.0
      BEGIN:VEVENT
      DTSTART;VALUE=DATE:20130726
      SUMMARY:testevent
      DTEND;VALUE=DATE:20130727
      LAST-MODIFIED:20130725T142824Z
      DTSTAMP:20130725T142824Z
      CREATED:20130725T142824Z
      UID:01ef8547
      END:VEVENT
      END:VCALENDAR
    EOS

    (testpath".configkhalconfig").write <<~EOS
      [calendars]
      [[test]]
      path = #{testpath}.calendartest
      color = light gray
      [sqlite]
      path = #{testpath}.calendarkhal.db
      [locale]
      firstweekday = 0
      [default]
      default_calendar = test
    EOS

    system bin"khal", "--no-color", "search", "testevent"
  end
end
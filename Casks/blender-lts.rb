cask "blender-lts" do
  arch arm: "arm64", intel: "x64"

  version "3.6.10"
  sha256 arm:   "4b31d2b6d648b9df9a85d1086ac25a13cefe0a90381d5d7eee3943ac836aad42",
         intel: "b585544b1018fe53c06f10b238be4c4c5429c55fbdc83e34f9547c4ddec2c53d"

  url "https:download.blender.orgreleaseBlender#{version.major_minor}blender-#{version}-macos-#{arch}.dmg"
  name "Blender"
  desc "Free and open-source 3D creation suite"
  homepage "https:www.blender.org"

  # NOTE: The download page contents may change once the newest version is no
  # longer an LTS version (i.e. 3.4 instead of 3.3 LTS) requiring further
  # changes to this setup.
  livecheck do
    url "https:www.blender.orgdownload"
    regex(%r{href=.*?blender[._-]v?(\d+(?:\.\d+)+)-macos-#{arch}\.dmg}i)
    strategy :page_match do |page, regex|
      # Match majorminor versions from LTS "download" page URLs
      lts_page = Homebrew::Livecheck::Strategy.page_content("https:www.blender.orgdownloadlts")
      next if lts_page[:content].blank?

      lts_versions =
        lts_page[:content].scan(%r{href=["'].*download(?:lts|releases)(\d+(?:[.-]\d+)+)["' >]}i)
                          .flatten
                          .uniq
                          .map { |v| Version.new(v) }
      next if lts_versions.blank?

      version_page = Homebrew::Livecheck::Strategy.page_content("https:www.blender.orgdownloadlts#{lts_versions.max}")
      next [] if version_page[:content].blank?

      # If the version page has a download link, return it as the livecheck version
      matched_versions = version_page[:content].scan(regex).flatten
      next matched_versions if matched_versions.present?

      # If the version page doesn't have a download link, check the download page
      # Ensure we only match LTS versions on the download page
      page.scan(regex)
          .flatten
          .select { |v| lts_versions.include?(Version.new(v).major_minor) }
    end
  end

  conflicts_with cask: "blender"
  depends_on macos: ">= :high_sierra"

  app "Blender.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}blender.wrapper.sh"
  binary shimscript, target: "blender"

  preflight do
    # make __pycache__ directories writable, otherwise uninstall fails
    FileUtils.chmod "u+w", Dir.glob("#{staged_path}*.app**__pycache__")

    File.write shimscript, <<~EOS
      #!binbash
      '#{appdir}Blender.appContentsMacOSBlender' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportBlender",
    "~LibrarySaved Application Stateorg.blenderfoundation.blender.savedState",
  ]
end